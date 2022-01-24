{ lib, fetchPypi, buildPythonPackage, pytest-runner, six, beautifulsoup4, requests, }:
buildPythonPackage rec {
  pname = "lyricwikia";
  version = "0.1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0l5lkvr3299x79i7skdiggp67rzgax3s00psd1zqkxfysq27jvc8";
  };

  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ six beautifulsoup4 requests ];
  # upstream has no code tests
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/enricobacis/lyricwikia";
    maintainers = [ maintainers.kmein ];
    description = "LyricWikia API for song lyrics";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
