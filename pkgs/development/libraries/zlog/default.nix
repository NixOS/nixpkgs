{ lib, stdenv, fetchFromGitHub, fetchpatch }:

stdenv.mkDerivation rec {
  version = "1.2.15";
  pname = "zlog";

  src = fetchFromGitHub {
    owner = "HardySimpson";
    repo = pname;
    rev = version;
    sha256 = "10hzifgpml7jm43y6v8c8q0cr9ziyx9qxznafxyw6glhnlqnb7pb";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2021-43521.patch";
      url = "https://github.com/HardySimpson/zlog/commit/a5be8b3a8ddc498de4ad041757285136a55d97e3.patch";
      sha256 = "sha256-igHXUHN2Ke8Gb5AeDrDwG2aUNRpispgqVlGuASute+8=";
    })
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description= "Reliable, high-performance, thread safe, flexible, clear-model, pure C logging library";
    homepage = "https://hardysimpson.github.io/zlog/";
    license = licenses.lgpl21;
    maintainers = [ maintainers.matthiasbeyer ];
    mainProgram = "zlog-chk-conf";
    platforms = platforms.unix;
  };

}
