{ stdenv
, buildPythonPackage
, fetchPypi
, fetchpatch
}:

buildPythonPackage rec {
  pname = "capstone";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "945d3b8c3646a1c3914824c416439e2cf2df8969dd722c8979cdcc23b40ad225";
  };

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
