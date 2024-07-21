{ fetchFromGitHub
, stdenvNoCC
, lib
, git
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
    hash = "sha256-omHlViym0hs02cn/25nUVtNVa38yowByttZ2vjqpWhs=";
    # If you use a builtin-baseline in a vcpkg.json file, then vcpkg will try
    # to run “git show <baseline-commit>”. We need a deep clone in order to
    # ensure that that works.
    deepClone = true;
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
  '';

  installPhase = ''
      runHook preInstall

      mkdir -p "$out/bin" "$out/libexec/vcpkg" "$out/share/vcpkg/scripts/buildsystems"
      cp --preserve=mode -r ./{.git,docs,ports,triplets,scripts,.vcpkg-root,versions,LICENSE.txt} "$out/share/vcpkg/"

      ${lib.optionalString doWrap ''
        # If you use a builtin-baseline in a vcpkg.json file, then vcpkg will
        # try to run “git show” on $out/share/vcpkg. By default, Git will fail
        # if a Git repo isn’t owned by the current user. We create a wrapper
        # for git here to make sure that the “git show” command succeeds, even
        # if the user running vcpkg doesn’t own $out/share/vcpkg.
        makeWrapper "${git}/bin/git" "$out/libexec/vcpkg/git" \
          --add-flags -c --add-flags safe.directory="$out/share/vcpkg"

        makeWrapper "${vcpkg-tool}/bin/vcpkg" "$out/bin/vcpkg" \
          --set-default VCPKG_ROOT "$out/share/vcpkg" \
          --prefix PATH : "$out/libexec/git"
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
