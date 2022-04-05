{ lib
, buildGoModule
, fetchFromGitHub
, llvm
, clang-unwrapped
, lld
, lldb
, libffi
, avrgcc
, avrdude
, openocd
, gcc-arm-embedded
, gdb
, makeWrapper
, fetchurl
, substituteAll
}:

let
  main = ./main.go;
  gomod = ./go.mod;
  llvm-major = lib.versions.major llvm.version;
  clang-envpatch = substituteAll {
    src = ./clang-env.patch;
    libclang_inc = "${clang-unwrapped.lib}/lib/clang/${clang-unwrapped.version}/include";
  };
in
buildGoModule rec {
  pname = "tinygo";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "tinygo-org";
    repo = "tinygo";
    rev = "v${version}";
    sha256 = "YgQGAQJw9Xyw5BF2d9uZTQHfjHsu2evZGo4RV9DtStE=";
    fetchSubmodules = true;
  };

  overrideModAttrs = (_: {
    patches = [ ];
    preBuild = ''
      rm -rf *
      cp ${main} main.go
      cp ${gomod} go.mod
      chmod +w go.mod
    '';
  });

  preBuild = "cp ${gomod} go.mod";

  postBuild = "make gen-device";

  vendorSha256 = "55NKFqtLvyx9Fn9aQlXKdVh6ZuoYLgovYTnL5T8q1F0=";

  doCheck = false;

  prePatch = ''
    patch -p0 < ${clang-envpatch}
  '';

  tags = [ "llvm14" ];

  subPackages = [ "." ];
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ llvm clang-unwrapped libffi ];
  propagatedBuildInputs = [ lld avrgcc avrdude openocd gcc-arm-embedded ];

  postInstall = ''
    mkdir -p $out/share/tinygo
    cp -a lib src targets $out/share/tinygo
    wrapProgram $out/bin/tinygo --prefix "TINYGOROOT" : "$out/share/tinygo" \
      --prefix "PATH" : "$out/libexec/tinygo"
    mkdir -p $out/libexec/tinygo
    ln -s ${clang-unwrapped}/bin/clang $out/libexec/tinygo/clang-${llvm-major}
    ln -s ${lld}/bin/lld $out/libexec/tinygo/ld.lld-${llvm-major}
    ln -s ${lldb}/bin/lldb $out/libexec/tinygo/lldb-${llvm-major}
    ln -s ${gdb}/bin/gdb $out/libexec/tinygo/gdb-multiarch
    ln -sf $out/bin $out/share/tinygo
  '';

  meta = with lib; {
    homepage = "https://tinygo.org/";
    description = "Go compiler for small places";
    license = licenses.bsd3;
    maintainers = with maintainers; [ Madouura ];
  };
}
