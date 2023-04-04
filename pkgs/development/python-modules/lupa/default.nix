{ lib
, buildPythonPackage
, cython
, fetchPypi
}:

buildPythonPackage rec {
  pname = "lupa";
  version = "2.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rT/vSGvnrd3TSf6anDk3iQYTEs+Y68UztIm+NPSEy3k=";
  };

  nativeBuildInputs = [ cython ];

  pythonImportsCheck = [ "lupa" ];

  meta = with lib; {
    description = "Lua in Python";
    homepage = "https://github.com/scoder/lupa";
    changelog = "https://github.com/scoder/lupa/blob/lupa-${version}/CHANGES.rst";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
