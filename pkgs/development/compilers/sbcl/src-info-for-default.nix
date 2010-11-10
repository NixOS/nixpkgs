{
  baseName = "sbcl";
  downloadPage = "http://sourceforge.net/projects/sbcl/files/";
  choiceCommand = "head -n 2| tail -n 1 | sed -e 's@/download@@;'\"$skipRedirectSF\"";
  sourceRegexp = "source[.-].*tar";
  versionExtractorSedScript = "s/.*-([0-9.rc]+)-.*/\\1/";
  blacklistRegexp = "1[.]0[.]3[012]|1[.]0[.]29[.]54[.]rc1";
}
