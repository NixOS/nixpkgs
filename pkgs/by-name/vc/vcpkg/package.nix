{ fetchFromGitHub
, stdenvNoCC
, lib
, vcpkg-tool
, makeWrapper
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

  installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/share/vcpkg/scripts/buildsystems"
      cp --preserve=mode -r ./{docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} "$out/share/vcpkg/"

      makeWrapper "${vcpkg-tool}/bin/vcpkg" "$out/bin/vcpkg" \
        --set-default VCPKG_ROOT "$out/share/vcpkg"

      ln -s "$out/bin/vcpkg" "$out/share/vcpkg/vcpkg"
      touch "$out/share/vcpkg/vcpkg.disable-metrics"

      runHook postInstall
    '';

  meta = {
    description = "C++ Library Manager";
    mainProgram = "vcpkg";
    homepage = "https://vcpkg.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ guekka gracicot ];
    platforms = lib.platforms.all;
  };
})
