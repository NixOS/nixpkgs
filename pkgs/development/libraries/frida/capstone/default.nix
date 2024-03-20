{ srcs, stdenv, ninja, meson, fixDarwinDylibNames, fetchFromGitHub, lib }:
stdenv.mkDerivation {
  pname = "capstone-frida";
  version = "5.0.0";
  src = fetchFromGitHub srcs.capstone;

  nativeBuildInputs = [
    ninja
    meson
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  mesonFlags = [
    "-Darchs=all"
    "-Duse_arch_registration=true"
    "-Dx86_att_disable=true"
    "-Dcli=disabled"
  ];

  dontUseCmakeConfigure = true;
  doCheck = true;

  meta = {
    maintainers = with lib.maintainers; [ lf- ];
    homepage = "https://github.com/frida/capstone";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    description = "Frida's forked version of the capstone disassembler";
  };
}

