'use strict'

const fs = require('fs')
const vm = require('vm')
const depsFile = String(fs.readFileSync('./DEPS'))

const path = require('path')

const targetOS = 'linux' // TODO: mac support

const processed = depsFile.replace(/#/g, '// ') + '\n deps;'

const ctx = vm.createContext({})

const script = new vm.Script(processed)
const deps = script.runInContext(ctx)

for (const id in deps) { // eslint-disable-line guard-for-in
  const { condition } = deps[id]
  if (condition && condition !== `checkout_${targetOS}`) {
    delete deps[id]
  }
}

let outScript = [`#!/bin/nix-shell
#!nix-shell -p nix-prefetch-git jq

set -xeuo pipefail

write_nix() {
  NIXFILE="$1"
  shift
  echo "$*" >> "$NIXFILE"
}

pipe_nix() {
  NIXFILE="$1"
  shift
  cat >> "$NIXFILE"
}

`]

function append (...stuff) {
  outScript = outScript.concat(
    stuff.reduce((out, add) => Array.isArray(add) ? out.concat(add) : out.concat([add]), [])
  )
}

function writeNix (file, str) {
  append(`write_nix "$${file}" "${str.replace(/"/g, '\\"').replace(/\${/g, '\\${')}"`)
}

function fetchGit (outPath, url) {
  const varName = outPath.replace(/\//g, '_')

  const [repo, checkout] = Array.isArray(url) ? url : url.split('@')
  append(`HASH=$(nix-prefetch-git ${repo} ${checkout} | jq -r .sha256)`)
  writeNix('SRC', `${varName} = fetchgit { url = "${repo}"; rev = "${checkout}"; sha256 = "$HASH" }`)
  writeNix('CONFIGURE', `mkdir -p ${path.dirname(outPath)} && cp -rp \${${varName}} ${outPath}`)
}

for (const outPath in deps) { // eslint-disable-line guard-for-in
  const dep = deps[outPath]

  if (typeof dep === 'string') {
    fetchGit(outPath, dep)
    continue
  }

  if (dep.url) {
    fetchGit(outPath, dep.url)
    continue
  }

  console.log(dep)
}

console.log(outScript.join('\n'))

fs.writeFileSync('./process.sh', outScript.join('\n'))
