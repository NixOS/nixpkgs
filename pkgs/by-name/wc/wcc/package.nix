{
  lib,
  stdenv,
  fetchFromGitHub,
  capstone,
  libbfd,
  libelf,
  libiberty,
  readline,
}:

stdenv.mkDerivation {
  pname = "wcc-unstable";
  version = "2018-04-05";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    rev = "f141963ff193d7e1931d41acde36d20d7221e74f";
    sha256 = "1f0w869x0176n5nsq7m70r344gv5qvfmk7b58syc0jls8ghmjvb4";
    fetchSubmodules = true;
  };

  buildInputs = [
    capstone
    libbfd
    libelf
    libiberty
    readline
  ];

  postPatch = ''
    sed -i src/wsh/include/libwitch/wsh.h src/wsh/scripts/INDEX \
      -e "s#/usr/share/wcc#$out/share/wcc#"

    sed -i -e '/stropts.h>/d' src/wsh/include/libwitch/wsh.h
  '';

  installFlags = [ "DESTDIR=$(out)" ];

  preInstall = ''
    mkdir -p $out/usr/bin
  '';

  postInstall = ''
    mv $out/usr/* $out
    rmdir $out/usr
    mkdir -p $out/share/man/man1
    cp doc/manpages/*.1 $out/share/man/man1/
  '';

  preFixup = ''
    # Let patchShebangs rewrite shebangs with wsh.
    PATH+=:$out/bin
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/endrazine/wcc";
    description = "Witchcraft compiler collection: tools to convert and script ELF files";
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ orivej ];
  };
}
