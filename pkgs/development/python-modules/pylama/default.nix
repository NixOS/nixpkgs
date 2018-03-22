{ lib, buildPythonPackage, fetchPypi, fetchpatch
, mccabe, pycodestyle, pydocstyle, pyflakes
, pytest, ipdb }:

buildPythonPackage rec {
  pname = "pylama";
  version = "7.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "390c1dab1daebdf3d6acc923e551b035c3faa77d8b96b98530c230493f9ec712";
  };

  patches = fetchpatch {
    url = "${meta.homepage}/pull/116.patch";
    sha256 = "00jz5k2w0xahs1m3s603j6l4cwzz92qsbbk81fh17nq0f47999mv";
  };

  propagatedBuildInputs = [ mccabe pycodestyle pydocstyle pyflakes ];

  checkInputs = [ pytest ipdb ];

  # tries to mess with the file system
  doCheck = false;

  meta = with lib; {
    description = "Code audit tool for python";
    homepage = https://github.com/klen/pylama;
    # ambiguous license declarations: https://github.com/klen/pylama/issues/64
    license = licenses.lgpl3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
