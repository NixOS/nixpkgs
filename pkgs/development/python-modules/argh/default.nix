{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, py
, mock
, pkgs
}:

buildPythonPackage rec {
  pname = "argh";
  version = "0.26.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nqham81ihffc9xmw85dz3rg3v90rw7h0dp3dy0bh3qkp4n499q6";
  };

  buildInputs = [ pytest py mock pkgs.glibcLocales ];

  checkPhase = ''
    export LANG="en_US.UTF-8"
    py.test
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/neithere/argh/;
    description = "An unobtrusive argparse wrapper with natural syntax";
    license = licenses.lgpl2;
    maintainers = with maintainers; [ domenkozar ];
  };

}
