{
  lib,
  fetchFromGitHub,
  jq,
  swift,
  swiftPackages,
  swiftpm,
  swiftpm2nix,
  testers,
  callPackage,
  xcodegen,
}:
let
  generated = swiftpm2nix.helpers ./generated;
in
swift.stdenv.mkDerivation rec {
  pname = "xcodegen";
  version = "2.42.0";

  src = fetchFromGitHub {
    owner = "yonaskolb";
    repo = "XcodeGen";
    rev = "${version}";
    sha256 = "sha256-wcjmADG+XnS2kR8BHe6ijApomucS9Tx7ZRjWZmTCUiI=";
  };

  patches = [
    ./0001-TestHelpers.patch
  ];

  configurePhase =
    generated.configure
    + ''
      swiftpmMakeMutable Spectre
      rm .build/checkouts/Spectre/Sources/Spectre/XCTest.swift
    '';

  nativeBuildInputs = [
    swift
    swiftpm
  ];

  buildInputs = [
    swiftPackages.XCTest
    jq
  ];

  installPhase = ''
    binPath="$(swiftpmBinPath)"
    mkdir -p $out/bin
    cp -r $binPath/xcodegen $out/bin
  '';

  passthru.tests.version = testers.testVersion { package = xcodegen; };

  meta = with lib; {
    description = "A Swift command line tool for generating your Xcode project";
    homepage = "https://github.com/yonaskolb/XcodeGen";
    license = licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = with maintainers; [ DimitarNestorov ];
  };
}
