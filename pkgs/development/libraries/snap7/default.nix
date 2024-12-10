{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchzip,
  p7zip,
}:

stdenv.mkDerivation rec {
  pname = "snap7";
  version = "1.4.2";

  src = fetchzip {
    url = "mirror://sourceforge/snap7/${version}/snap7-full-${version}.7z";
    sha256 = "1n5gs8bwb6g9vfllf3x12r5yzqzapmlq1bmc6hl854b8vkg30y8c";
    postFetch = ''
      ${p7zip}/bin/7z x $downloadedFile
      mkdir $out
      cp -r snap7-full-${version}/* $out/
    '';
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  makefile = "x86_64_linux.mk";
  makeFlags = [ "LibInstall=$(out)/lib" ];

  preBuild = "cd build/unix";
  preInstall = ''
    mkdir -p $out/lib
    mkdir -p $dev/include
    mkdir -p $doc/share
    cp $src/examples/cpp/snap7.h $dev/include
    cp -r $src/doc $doc/share/
  '';

  meta = with lib; {
    homepage = "https://snap7.sourceforge.net/";
    description = "Step7 Open Source Ethernet Communication Suite";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ freezeboy ];
    platforms = platforms.linux;
  };
}
