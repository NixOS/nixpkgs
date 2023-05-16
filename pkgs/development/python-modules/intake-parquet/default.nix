{ lib
, buildPythonPackage
, fetchFromGitHub
, pandas
, dask
, fastparquet
, pyarrow
}:

buildPythonPackage rec {
  pname = "intake-parquet";
<<<<<<< HEAD
  version = "0.3.0";
=======
  version = "0.2.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "intake";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-zSwylXBKOM/tG5mwYtc0FmxwcKJ6j+lw1bxJqf57NY8=";
=======
    sha256 = "037jd3qkk6dybssp570kzvaln2c6pk2avd2b5mll42gaxdxxnp02";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pandas
    dask
    fastparquet
    pyarrow
  ];

  postPatch = ''
    # Break circular dependency
    substituteInPlace requirements.txt \
      --replace "intake" ""
  '';

  doCheck = false;

  #pythonImportsCheck = [ "intake_parquet" ];

  meta = with lib; {
    description = "Parquet plugin for Intake";
    homepage = "https://github.com/intake/intake-parquet";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
  };
}
