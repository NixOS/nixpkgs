{ lib, stdenv, fetchFromGitHub, capstone, libbfd, libelf, libiberty, readline }:

stdenv.mkDerivation {
  pname = "wcc-unstable";
  version = "2023-02-04";

  src = fetchFromGitHub {
    owner = "endrazine";
    repo = "wcc";
    rev = "825448004e5e53c3ab9a9dac0886544bc499d259";
    sha256 = "sha256-Cy7CkqzpgmNPQrg/ubTxLi8vWMSQtGY/a7Trb3e6L+o=";
    fetchSubmodules = true;
  };

  buildInputs = [ capstone libbfd libelf libiberty readline ];

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
