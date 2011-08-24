{
  downloadPage = "http://webkitgtk.org/?page=download";
  versionExtractorSedScript = "s/.*-([.0-9]+)[.].*/\\1/";
  versionReferenceCreator = "s/-([.0-9.]+)[.]/-\${version}./";
  baseName = "webkit";
}
