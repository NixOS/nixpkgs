{
  fetchFromGitHub,
  fetchpatch,
  lib,
  stdenv,
  # nativeBuildInputs
  cmake,
  ninja,
}:
stdenv.mkDerivation (finalAttrs: {
  strictDeps = true;
  pname = "psimd";
  version = finalAttrs.src.rev;
  src = fetchFromGitHub {
    owner = "Maratyszcza";
    repo = finalAttrs.pname;
    rev = "072586a71b55b7f8c584153d223e95687148a900";
    hash = "sha256-lV+VZi2b4SQlRYrhKx9Dxc6HlDEFz3newvcBjTekupo=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/Maratyszcza/psimd/pull/5.patch";
      hash = "sha256-fw9+Z//Qv5pX6aly3HacRnhjNBsuIGUsA2OYmqV7yrk=";
    })
  ];
  nativeBuildInputs = [
    cmake
    ninja
  ];
  doCheck = true;
  meta = with lib; {
    description = "Portable 128-bit SIMD intrinsics";
    homepage = "https://github.com/Maratyszcza/psimd";
    license = licenses.mit;
    maintainers = with maintainers; [connorbaker];
    platforms = platforms.all;
  };
})
