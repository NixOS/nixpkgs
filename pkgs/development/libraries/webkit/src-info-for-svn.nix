{
  downloadPage = "http://nightly.webkit.org/";
  versionExtractorSedScript = "s/.*-(r[0-9]+)[.].*/\\1/";
  versionReferenceCreator = "s/-(r[0-9.]+)[.]/-\${version}./";
  baseName = "webkit";
}
