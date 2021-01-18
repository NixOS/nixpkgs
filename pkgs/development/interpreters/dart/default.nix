{ stdenv, fetchurl, unzip, version ? "2.10.4" }:

let

  sources = let

    base = "https://storage.googleapis.com/dart-archive/channels";
    stable_version = "stable";
    dev_version = "dev";
    x86_64 = "x64";
    i686 = "ia32";
    aarch64 = "arm64";

  in {
    "1.24.3-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "1n4cq4jrms4j0yl54b3w14agcgy8dbipv5788jziwk8q06a8c69l";
    };
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
    "2.10.4-x86_64-darwin" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "1d18l8ja8dckzs2y0fxwdbwh06fxzlx0fyhabcgxsvh3xg9qxhj5";
    };
    "2.10.4-x86_64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "0pjqj2bsliq13q8b2mk2v07w4vzjqcmr984ygnwv5kx0dp5md7vq";
    };
    "2.10.4-i686-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "0fyqfikbd85jrckzvxvq7npb2l2kqzifg8pm2jy0ivr5lb1021r8";
    };
    "2.10.4-aarch64-linux" = fetchurl {
      url = "${base}/${stable_version}/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "04743g0z8fcv757jlcrbf6v8m3f0fz5smjmv9n4a6fprfzj8bw0k";
    };
    "2.12.0-223.0.dev-x86_64-darwin" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-macos-${x86_64}-release.zip";
      sha256 = "04g41ybq4ldnzryzk0fp9cw0frm6s7ycc05f6b7yz864fvpjby3n";
    };
    "2.12.0-223.0.dev-x86_64-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${x86_64}-release.zip";
      sha256 = "1rr95d1hj0wxqwcvrkwy2dmhbi02lqz8d4k5sxwrhh3rzkd0l44q";
    };
    "2.12.0-223.0.dev-i686-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${i686}-release.zip";
      sha256 = "0nxl3srlgwplypsh4yky4rxspk0paqj8jrz3kj0rx9y8cis564lz";
    };
    "2.12.0-223.0.dev-aarch64-linux" = fetchurl {
      url = "${base}/${dev_version}/release/${version}/sdk/dartsdk-linux-${aarch64}-release.zip";
      sha256 = "04zcc954ai4d2lr65m7cknkhh53yy4zrqsdqml7x20i5y8i5ybxa";
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
    find $out/bin -executable -type f -exec patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) {} \;
  '';

  dontStrip = true;

  meta = {
    homepage = "https://www.dartlang.org/";
    maintainers = with maintainers; [ grburst ];
    description = "Scalable programming language, with robust libraries and runtimes, for building web, server, and mobile apps";
    longDescription = ''
      Dart is a class-based, single inheritance, object-oriented language
      with C-style syntax. It offers compilation to JavaScript, interfaces,
      mixins, abstract classes, reified generics, and optional typing.
    '';
    platforms = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
    license = licenses.bsd3;
  };
}
