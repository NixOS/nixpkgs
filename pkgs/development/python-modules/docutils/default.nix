{ lib
, fetchurl
, buildPythonPackage
, isPy3k
, python
}:

buildPythonPackage rec {
  pname = "docutils";
  version = "0.14";

  src = fetchurl {
    url = "mirror://sourceforge/docutils/${pname}.tar.gz";
    sha256 = "0x22fs3pdmr42kvz6c654756wja305qv6cx1zbhwlagvxgr4xrji";
  };

  checkPhase = if isPy3k then ''
    ${python.interpreter} test3/alltests.py
  '' else ''
    ${python.interpreter} test/alltests.py
  '';

  # Create symlinks lacking a ".py" suffix, many programs depend on these names
  postFixup = ''
    (cd $out/bin && for f in *.py; do
      ln -s $f $(echo $f | sed -e 's/\.py$//')
    done)
  '';

  meta = {
    description = "Docutils -- Python Documentation Utilities";
    homepage = http://docutils.sourceforge.net/;
    maintainers = with lib.maintainers; [ garbas AndersonTorres ];
  };
}
