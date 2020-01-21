{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
, setuptools
}:

buildPythonPackage rec {
  pname = "capstone";
  version = "3.0.5.post1";

  setupPyBuildFlags = [
    "--plat-name x86_64-linux"
  ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "3c0f73db9f8392f7048c8a244809f154d7c39f354e2167f6c477630aa517ed04";
  };

  propagatedBuildInputs = [ setuptools ];

  patches = [
    (fetchpatch {
      stripLen = 2;
      url = "https://patch-diff.githubusercontent.com/raw/aquynh/capstone/pull/783/commits/23fe9f36622573c747e2bab6119ff245437bf276.patch";
      sha256 = "0yizqrdlxqxn16873593kdx2vrr7gvvilhgcf9xy6hr0603d3m5r";
    })
  ];

  postPatch = ''
    patchShebangs src/make.sh
  '';

  preCheck = ''
    mv src/libcapstone.so capstone
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.capstone-engine.org/";
    license = licenses.bsdOriginal;
    description = "Capstone disassembly engine";
    maintainers = with maintainers; [ bennofs ];
  };
}
