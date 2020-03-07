{ stdenv, fetchFromGitHub, buildPythonPackage
, packaging }:

buildPythonPackage rec {
  pname = "fastprogress";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = pname;
    rev = "90e3ed8f950a9a170f1141f2b40e8694736eff34";
    sha256 = "17p67280lrwc534xdynbafbzixm8rxbh5ncqr8rzvyb9px7vqc1j";
  };

  propagatedBuildInputs = [
    packaging
  ];

  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "Simple and flexible progress bar for Jupyter Notebook and console";
    homepage = "https://github.com/fastai/fastprogress";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
