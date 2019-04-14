{ stdenv
, buildPythonPackage
, fetchPypi
, future
}:

buildPythonPackage rec {
  pname = "annexremote";
  version = "1.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "058d39fd59db165f0014601da1ba9ecde7614de87eef3061e9ea0b1dd096a9cd";
  };

  propagatedBuildInputs = [ future ];

  meta = with stdenv.lib; {
    description = "git annex special remotes made easy";
    homepage = https://pypi.org/project/annexremote/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ montag451 ];
  };
}
