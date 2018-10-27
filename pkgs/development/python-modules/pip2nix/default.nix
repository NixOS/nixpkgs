{ stdenv
, buildPythonPackage
, fetchPypi
, click
, configobj
, contexter
, jinja2
, pytest
}:

buildPythonPackage rec {
  pname = "pip2nix";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ec9a71e09ac7f43cc7b6c9d386384eb7b5c331bf6ea0e72ca559d87979397a95";
  };

  propagatedBuildInputs = [ click configobj contexter jinja2 pytest ];

  postPatch = ''
    sed -i "s/'pip>=8,<10'/'pip'/" setup.py
    sed -i "s/pip<10,>=8/pip/" ${pname}.egg-info/requires.txt
  '';

  # tests not included with pypi release
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate Nix expressions for Python packages";
    homepage = https://github.com/johbo/pip2nix;
    license = licenses.gpl3;
  };

}
