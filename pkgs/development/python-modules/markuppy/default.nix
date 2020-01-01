{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "markuppy";
  version = "1.14";

  src = fetchPypi {
    pname = "MarkupPy";
    inherit version;
    sha256 = "1adee2c0a542af378fe84548ff6f6b0168f3cb7f426b46961038a2bcfaad0d5f";
  };

  meta = with lib; {
    description = "An HTML/XML generator";
    homepage = https://github.com/tylerbakke/MarkupPy;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
