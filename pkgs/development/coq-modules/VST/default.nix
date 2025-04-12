{
  lib,
  mkCoqDerivation,
  coq,
  compcert,
  ITree,
  version ? null,
}:

# A few modules that are not built and installed by default
#  but that may be useful to some users.
# They depend on ITree.
let
  extra_floyd_files =
    [
      "ASTsize.v"
      "io_events.v"
      "powerlater.v"
    ]
    # floyd/printf.v is broken in VST 2.9
    ++ lib.optional (!lib.versions.isGe "8.13" coq.coq-version) "printf.v"
    ++ [
      "quickprogram.v"
    ];
in

mkCoqDerivation {
  pname = "coq${coq.coq-version}-VST";
  namePrefix = [ ];
  displayVersion = {
    coq = false;
  };
  owner = "PrincetonUniversity";
  repo = "VST";
  inherit version;
  defaultVersion =
    with lib.versions;
    lib.switch coq.coq-version [
      {
        case = range "8.15" "8.19";
        out = "2.14";
      }
      {
        case = range "8.15" "8.17";
        out = "2.13";
      }
      {
        case = range "8.14" "8.16";
        out = "2.10";
      }
      {
        case = range "8.13" "8.15";
        out = "2.9";
      }
      {
        case = range "8.12" "8.13";
        out = "2.8";
      }
    ] null;
  release."2.14".sha256 = "sha256-NHc1ZQ2VmXZy4lK2+mtyeNz1Qr9Nhj2QLxkPhhQB7Iw=";
  release."2.13".sha256 = "sha256-i6rvP3cpayBln5KHZOpeNfraYU5h0O9uciBQ4jRH4XA=";
  release."2.12".sha256 = "sha256-4HL0U4HA5/usKNXC0Dis1UZY/Hb/LRd2IGOrqrvdWkw=";
  release."2.11.1".sha256 = "sha256-unpNstZBnRT4dIqAYOv9n1J0tWJMeRuaaa2RG1U0Xs0=";
  release."2.10".sha256 = "sha256-RIxfPWoHnV1CFkpxCusoGY/LIk07TgC7wWGRP4BSq8w=";
  release."2.9".sha256 = "sha256:1adwzbl1pprrrwrm7cm493098fizxanxpv7nyfbvwdhgbhcnv6qf";
  release."2.8".sha256 = "sha256-cyK88uzorRfjapNQ6XgQEmlbWnDsiyLve5po1VG52q0=";
  releaseRev = v: "v${v}";
  buildInputs = [ ITree ];
  propagatedBuildInputs = [ compcert ];

  preConfigure = ''
    patchShebangs util
    substituteInPlace Makefile \
      --replace 'COQVERSION= ' 'COQVERSION= 8.19.2 or-else 8.17.1 or-else 8.16.1 or-else 8.16.0 or-else 8.15.2 or-else 8.15.1 or-else '\
      --replace 'FLOYD_FILES=' 'FLOYD_FILES= ${toString extra_floyd_files}'
  '';

  makeFlags = [
    "BITSIZE=64"
    "COMPCERT=inst_dir"
    "COMPCERT_INST_DIR=${compcert.lib}/lib/coq/${coq.coq-version}/user-contrib/compcert"
    "INSTALLDIR=$(out)/lib/coq/${coq.coq-version}/user-contrib/VST"
  ];

  postInstall = ''
    for d in msl veric floyd sepcomp progs64
    do
      cp -r $d $out/lib/coq/${coq.coq-version}/user-contrib/VST/
    done
  '';

  meta = {
    description = "Verified Software Toolchain";
    homepage = "https://vst.cs.princeton.edu/";
    inherit (compcert.meta) platforms;
  };
}
