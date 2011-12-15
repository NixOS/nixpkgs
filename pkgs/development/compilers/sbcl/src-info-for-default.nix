{
  baseName = "sbcl";
  downloadPage = "http://sourceforge.net/projects/sbcl/files/sbcl/";
  choiceCommand = "head -n 1 | sed -re 's%.*/([0-9.]+)/%http://downloads.sourceforge.net/project/sbcl/sbcl/\\1/sbcl-\\1-source.tar.bz2%'";
  sourceRegexp = "[/][0-9.]+/\$";
  versionExtractorSedScript = "s/.*-([0-9.rc]+)-.*/\\1/";
}
