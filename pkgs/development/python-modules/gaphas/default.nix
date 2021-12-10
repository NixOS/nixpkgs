{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, gobject-introspection
, gtk3
, pycairo
, pygobject3
, typing-extensions
}:

buildPythonPackage rec {
  pname = "gaphas";
  version = "3.1.9";
  disabled = pythonOlder "3.7";

  format = "pyproject";

  src = fetchFromGitHub {
     owner = "gaphor";
     repo = "gaphas";
     rev = "3.1.9";
     sha256 = "03mnxi0r5cs4pn9qmac2brb1ib2nyqzp5vcma2jaccldhapxss95";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [ gobject-introspection gtk3 ];

  propagatedBuildInputs = [
    pycairo
    pygobject3
    typing-extensions
  ];

  pythonImportsCheck = [ "gaphas" ];

  meta = with lib; {
    description = "GTK+ based diagramming widget";
    maintainers = with maintainers; [ wolfangaukang ];
    homepage = "https://github.com/gaphor/gaphas";
    license = licenses.asl20;
  };
}
