{
  downloadPage = "http://sourceforge.net/projects/ecls/files/";
  baseName = "ecl";
  choiceCommand = "head -1 | sed -e 's@/download@@;'\"$skipRedirectSF\"";
  sourceRegexp = ".*[.](tar.gz|tgz|tbz2|tar.bz2)";
}
