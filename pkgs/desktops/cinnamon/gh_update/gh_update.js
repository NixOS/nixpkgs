#!/usr/bin/env node

'use strict'

// Get the latest tag matching the semver policy for the specified github slug

const fetch = require('node-fetch')
const Semver = require('semver')

const log = console.error // eslint-disable-line no-console

const wait = (i) => new Promise((resolve, reject) => setTimeout(resolve, i))

async function fetchReleases (slug, page, id) {
  const params = {}

  if (page) {
    params.page = page
  }

  const url = `https://api.github.com/repos/${slug}/releases${id ? `/${id}` : '?' + String(new URLSearchParams(params))}`

  log('GET %s', url)
  const res = await fetch(url)

  if (res.status === 403) { // we're out of requests, wait
    log('Out of requests, waiting 5 mins...')
    await wait(5 * 60 * 1000)
    return fetchReleases(slug, page, id)
  }

  if (res.status - (res.status % 100) !== 200) {
    throw new Error(`Failed to fetch data: ${res.status}`)
  }

  return {
    res: await res.json(),
    next: res.headers.get('link') && res.headers.get('link').indexOf('next') !== -1
  }
}

async function fetchTags (slug, page, id) {
  const params = {}

  if (page) {
    params.page = page
  }

  const url = `https://api.github.com/repos/${slug}/tags${id ? `/${id}` : '?' + String(new URLSearchParams(params))}`

  log('GET %s', url)
  const res = await fetch(url)

  if (res.status === 403) { // we're out of requests, wait
    log('Out of requests, waiting 5 mins...')
    await wait(5 * 60 * 1000)
    return fetchReleases(slug, page, id)
  }

  if (res.status - (res.status % 100) !== 200) {
    throw new Error(`Failed to fetch data: ${res.status}`)
  }

  return {
    res: await res.json(),
    next: res.headers.get('link') && res.headers.get('link').indexOf('next') !== -1
  }
}

function releasesProcessVersions (semver, versionList) {
  return versionList.res.filter(v => {
    if (v.prerelease || v.draft) return false
    if (!semver) return true
    return Semver.satisfies(v.tag_name.replace(/^v/, ''), semver)
  })
}

function tagsProcessVersions (semver, versionList) {
  return versionList.res.filter(v => {
    if (!semver) return true
    return Semver.satisfies(v.name.replace(/^v/, ''), semver)
  })
}

async function fetchLatestMatching (slug, semver) {
  let page = 1

  let versionFound

  while (!versionFound) {
    const res = await fetchReleases(slug, page)

    const versions = await releasesProcessVersions(semver, res)

    if (versions.length) {
      versionFound = versions[0]
    }

    if (!res.next) { break }

    page++
  }

  page = 1

  while (!versionFound) {
    const res = await fetchTags(slug, page)

    const versions = await tagsProcessVersions(semver, res)

    if (versions.length) {
      versionFound = versions[0]
    }

    if (!res.next) { break }
  }

  if (!versionFound) {
    throw new Error('Semver policy isn\'t matching anything at all - Is it even correct?')
  }

  console.log(versionFound.tag_name || versionFound.name) // eslint-disable-line no-console
}

fetchLatestMatching(...process.argv.slice(2))
