{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
  cmigemo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cmigemo";
  version = "0.1.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cxOqMAf2dgCwZuBKSAXkRFY9FRNB3rMwE1tNzfZERiY=";
  };

  propagatedBuildInputs = [ six ];

  preConfigure = ''
    export LDFLAGS="-L${cmigemo}/lib"
    export CPPFLAGS="-I${cmigemo}/include"
    export LD_LIBRARY_PATH="${cmigemo}/lib"
  '';

  postPatch = ''
    sed -i 's~dict_path_base = "/usr/share/cmigemo"~dict_path_base = "/${cmigemo}/share/migemo"~g' test/test_cmigemo.py
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "test/" ];

  pythonImportsCheck = [ "cmigemo" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/mooz/python-cmigemo";
    description = "Pure python binding for C/Migemo";
    license = licenses.mit;
    maintainers = with maintainers; [ illustris ];
  };
}
