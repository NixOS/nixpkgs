{ stdenv, fetchFromGitHub, coreutils, cpio, findutils, gzip, makeWrapper, utillinux }:

let
  version = "0.6";
in
stdenv.mkDerivation {
  pname = "abootimg";
  inherit version;

  src = fetchFromGitHub {
    owner = "ggrandou";
    repo = "abootimg";
    rev = "7e127fee6a3981f6b0a50ce9910267cd501e09d4";
    sha256 = "1qgx9fxwhylgnixzkz2mzv2707f65qq7rar2rsqak536vhig1z9a";
  };

  nativeBuildInputs = [ makeWrapper utillinux ];

  postPatch = ''
    cat <<EOF > version.h
    #define VERSION_STR "${version}"
    EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -D -m 755 abootimg $out/bin
    install -D -m444 ./debian/abootimg.1 $out/share/man/man1/abootimg.1;

    install -D -m 755 abootimg-pack-initrd $out/bin
    wrapProgram $out/bin/abootimg-pack-initrd --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils cpio findutils gzip ]}

    install -D -m 755 abootimg-unpack-initrd $out/bin
    wrapProgram $out/bin/abootimg-unpack-initrd --prefix PATH : ${stdenv.lib.makeBinPath [ cpio gzip ]}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/ggrandou/abootimg;
    description = "Manipulate Android Boot Images";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.flokli ];
  };
}
