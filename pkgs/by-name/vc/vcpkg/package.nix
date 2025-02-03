{ fetchFromGitHub
, stdenvNoCC
, lib
, vcpkg-tool
, makeWrapper
, doWrap ? true
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vcpkg";
  version = "2024.06.15";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "vcpkg";
    rev = finalAttrs.version;
    hash = "sha256-eDpMGDtC44eh0elLWV0r1H/WbpVdZ5qMedKh7Ct50Cs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    substituteInPlace scripts/toolchains/linux.cmake \
      --replace-fail "aarch64-linux-gnu-as"  "aarch64-unknown-linux-gnu-as" \
      --replace-fail "aarch64-linux-gnu-gcc" "aarch64-unknown-linux-gnu-gcc" \
      --replace-fail "aarch64-linux-gnu-g++" "aarch64-unknown-linux-gnu-g++" \
      --replace-fail "arm-linux-gnueabihf-as"  "armv7l-unknown-linux-gnueabihf-as" \
      --replace-fail "arm-linux-gnueabihf-gcc" "armv7l-unknown-linux-gnueabihf-gcc" \
      --replace-fail "arm-linux-gnueabihf-g++" "armv7l-unknown-linux-gnueabihf-g++"
    # If we don’t turn this off, then you won’t be able to run binaries that
    # are installed by vcpkg.
    find triplets -name '*linux*.cmake' -exec bash -c 'echo "set(X_VCPKG_RPATH_KEEP_SYSTEM_PATHS ON)" >> "$1"' -- {} \;
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/vcpkg/scripts/buildsystems"
      cp --preserve=mode -r ./{docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} "$out/share/vcpkg/"

      ${lib.optionalString doWrap ''
        makeWrapper "${vcpkg-tool}/bin/vcpkg" "$out/bin/vcpkg" \
          --set-default VCPKG_ROOT "$out/share/vcpkg"
      ''}

      ln -s "$out/bin/vcpkg" "$out/share/vcpkg/vcpkg"
      touch "$out/share/vcpkg/vcpkg.disable-metrics"

      runHook postInstall
    '';

  meta = {
    description = "C++ Library Manager";
    mainProgram = "vcpkg";
    homepage = "https://vcpkg.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot h7x4 ];
    platforms = lib.platforms.all;
  };
})
