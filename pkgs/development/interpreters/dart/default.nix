{ stdenv, fetchurl, unzip, version ? "2.7.1" }:

let

  sources = let

    base = "https://storage.googleapis.com/dart-archive/channels";
    stable_version = "stable";
    dev_version = "dev";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";

  in {
    "1.24.3-x86_64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "16sm02wbkj328ni0z1z4n4msi12lb8ijxzmbbfamvg766mycj8z3";
    };
    "1.24.3-i686-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "0a559mfpb0zfd49zdcpld95h2g1lmcjwwsqf69hd9rw6j67qyyyn";
    };
    "1.24.3-aarch64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "1p5bn04gr91chcszgmw5ng8mlzgwsrdr2v7k7ppwr1slkx97fsrh";
    };
    "2.7.1-x86_64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "1zjd9hxxg1dsyzkzgqjvl933kprf8h143z5qi4mj1iczxv7zp27a";
    };
    "2.7.1-i686-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "0cggr1jbhzahmazlhba0vw2chz9zxd98jgk6zxvxdnw5hvkx8si1";
    };
    "2.7.1-aarch64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "0m4qlc3zy87habr61npykvpclggn5k4hadl59v2b0ymvxa4h5zfh";
    };
    "2.8.0-dev.10.0-x86_64-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "17x0q94zampm99dd2sn6q1644lfwcl0ig2rdlmfzd9i4llj2ddbl";
    };
    "2.8.0-dev.10.0-i686-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "0hmkg4jrffzh8x2mxn8nbf7dl7k0v2vacbmxgpsl382vw9wwj96j";
    };
    "2.8.0-dev.10.0-aarch64-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "185ipcmr9h76g44kzlj5pyj99cljlap82rhd1c2larfklyj5ryvv";
    };
  };

in

with stdenv.lib;

stdenv.mkDerivation {

  pname = "dart";
  inherit version;

  nativeBuildInputs = [
    unzip
  ];

  src = sources."${version}-${stdenv.hostPlatform.system}" or (throw "unsupported version/system: ${version}/${stdenv.hostPlatform.system}");

  installPhase = ''
    mkdir -p $out
    cp -R * $out/
    echo $libPath
    patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             --set-rpath $libPath \
             $out/bin/dart
  '';

  libPath = makeLibraryPath [ stdenv.cc.cc ];

  dontStrip = true;

  meta = {
    homepage = https://www.dartlang.org/;
    maintainers = with maintainers; [ grburst ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
    license = licenses.bsd3;
  };
}
