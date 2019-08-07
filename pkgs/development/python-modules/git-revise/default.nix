{ stdenv, fetchPypi, buildPythonPackage
, black, pylint, pytest
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mq1fh8m6jxl052d811cgpl378hiq20a8zrhdjn0i3dqmxrcb8vs";
  };

  checkInputs = [
    black pylint pytest
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mystor/git-revise;
    license = [ licenses.mit ];
    description = "A handy tool for doing efficient in-memory commit rebases & fixups";
    maintainers = [ maintainers.mmlb ];
  };
}
