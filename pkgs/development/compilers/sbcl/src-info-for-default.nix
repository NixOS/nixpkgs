{
  baseName = "sbcl";
  downloadPage = "http://www.sbcl.org/platform-table.html";
  choiceCommand = "head -1 | sed -e 's/[?].*//'";
  versionExtractorSedScript = "s/.*-([0-9.]+)-.*/\\1/";
}
