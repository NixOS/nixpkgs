{
  downloadPage = "http://dynamo.iro.umontreal.ca/~gambit/wiki/index.php/Main_Page";
  baseName = "gambit";
  sourceRegexp = "[.]tgz";
  versionExtractorSedScript = ''s/.*-(v[_0-9]+)-devel[.].*/\1/'';
  versionReferenceCreator = ''$(replaceAllVersionOccurences)'';
}
