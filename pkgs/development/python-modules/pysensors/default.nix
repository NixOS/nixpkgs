{ stdenv, buildPythonPackage, python, fetchFromGitHub, lm_sensors }:
buildPythonPackage {
  version = "2017-07-13";
  pname = "pysensors";

  # note that https://pypi.org/project/PySensors/ is a different project
  src = fetchFromGitHub {
    owner = "bastienleonard";
    repo = "pysensors";
    rev = "ef46fc8eb181ecb8ad09b3d80bc002d23d9e26b3";
    sha256 = "1xvbxnkz55fk5fpr514263c7s7s9r8hgrw4ybfaj5a0mligmmrfm";
  };

  buildInputs = [ lm_sensors ];

  # Tests are disable because they fail on `aarch64-linux`, probably
  # due to sandboxing
  doCheck = false;

  checkPhase = ''
    cd tests
    ${python.interpreter} -m unittest discover
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ guibou ];
    description = "Easy hardware health monitoring in Python for Linux systems";
    homepage = "https://pysensors.readthedocs.org";
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
