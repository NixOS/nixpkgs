{
  buildDunePackage,
  mparser,
  re,
}:

buildDunePackage {
  pname = "mparser-re";
  inherit (mparser) src version;

  propagatedBuildInputs = [
    mparser
    re
  ];

  meta = mparser.meta // {
    description = "MParser plugin: RE-based regular expressions";
  };
}
