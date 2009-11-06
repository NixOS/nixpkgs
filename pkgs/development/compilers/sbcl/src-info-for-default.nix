{
  baseName = "sbcl";
  downloadPage = "http://sourceforge.net/projects/sbcl/files/";
  choiceCommand = "head -1 | sed -e 's@/download@@;'\"$skipRedirectSF\"";
  sourceRegexp = "source[.]tar";
  versionExtractorSedScript = "s/.*-([0-9.]+)-.*/\\1/";
  blacklistRegexp = "1[.]0[.]3[12]";
}
