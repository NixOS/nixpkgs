{
  lib,
  buildPythonPackage,
  fetchPypi,
  lilypond,
}:

buildPythonPackage rec {
  pname = "jianpu-ly";
  version = "1.801";
  format = "setuptools";

  src = fetchPypi {
    inherit version;
    pname = "jianpu_ly";
    sha256 = "sha256-piK9Ym94cKdaHGz/ogX7ylyAF1ww0jCdRXnHN6lu2MI=";
  };

  nativeBuildInputs = [ lilypond ];

  pythonImportsCheck = [ "jianpu_ly" ];
  # no tests in shipped with upstream
  doCheck = false;

  meta = with lib; {
    homepage = "https://ssb22.user.srcf.net/mwrhome/jianpu-ly.html";
    description = "jianpu-ly is a Python program that assists with printing jianpu";
    license = licenses.asl20;
    maintainers = with maintainers; [ ifurther ];
    platforms = platforms.all;
  };
}
