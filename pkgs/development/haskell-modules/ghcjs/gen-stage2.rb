#!/usr/bin/env ruby

require 'pathname'

# from boot.yaml in ghcjs/ghcjs
stage2_packages = [
  "boot/async",
  "boot/aeson",
  "boot/attoparsec",
  "boot/case-insensitive",
  "boot/dlist",
  "boot/extensible-exceptions",
  "boot/hashable",
  "boot/mtl",
  "boot/old-time",
  "boot/parallel",
  "boot/scientific",
  "boot/stm",
  "boot/syb",
  "boot/text",
  "boot/unordered-containers",
  "boot/vector",
  "ghcjs/ghcjs-base",
  # not listed under stage2, but needed when "quick booting".
  "boot/cabal/Cabal"
]

nixpkgs = File.expand_path("../../../../..", __FILE__)
boot = `nix-build #{nixpkgs} -A haskell.packages.ghcjs.ghc.ghcjsBoot`.chomp

stage2_packages.each do |package|
  name = Pathname.new(package).basename
  nix = `cabal2nix file://#{boot}/#{package}  --jailbreak`
  nix.sub!(/src =.*?$/, "src = \"${ghcjsBoot}/#{package}\";")
  nix.sub!("libraryHaskellDepends", "doCheck = false;\n  libraryHaskellDepends")
  nix = nix.split("\n").join("\n    ")

  out = "".dup
  out << "#{name} = callPackage\n"
  out << "  (#{nix}) {};"

  puts out
end
