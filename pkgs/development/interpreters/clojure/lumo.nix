{ stdenv, fetchFromGitHub, boot, nodejs-8_x, yarn, python }:

stdenv.mkDerivation rec {
  name = "lumo-${version}";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "anmonteiro";
    repo = "lumo";
    rev = "fb97ce5086928252b8dd5b862a2d62d5e3daf825";
    sha256 = "0ci9rgpaww558sbvxkpf69rlkc4029ih70rja9vlr9a2nsp72cqp";
  };

  nativeBuildInputs = [
    boot
    nodejs-8_x
    python
    yarn
  ];

  buildPhase = ''
     # remove audible build notifications
     sed -i '/notify :audible true/d' build.boot

     mkdir boot_home m2_home

     BOOT_HOME=boot_home BOOT_LOCAL_REPO=m2_home \
       boot release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/lumo $out/bin
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/anmonteiro/lumo/;
    description = "Fast, cross-platform, standalone ClojureScript environment";
    maintainers = [ maintainers.andreivolt ];
    license = licenses.epl10;
    platforms = platforms.all;
  };
}
