{ stdenv, fetchPypi, buildPythonPackage
, traits, apptools
, ipykernel
}:

buildPythonPackage rec {
  pname = "envisage";
  version = "4.7.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0jb5nw0w9x97jij0hd3d7kfzcj58r1cqmplmdy56bj11dyc4wyc9";
  };

  propagatedBuildInputs = [ traits apptools ];

  preCheck = ''
    export HOME=$PWD/HOME
  '';

  checkInputs = [
    ipykernel
  ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Framework for building applications whose functionalities can be extended by adding 'plug-ins'";
    homepage = https://github.com/enthought/envisage;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    license = licenses.bsdOriginal;
  };
}
