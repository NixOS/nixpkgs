{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
  gitUpdater,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  gtest,
  libnotify,
  pkg-config,
  polkit,
  properties-cpp,
  python3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-polkit-agent";
  version = "0.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-polkit-agent";
    rev = finalAttrs.version;
    hash = "sha256-nA2jkyNQC1YIMpJkfJt2F97txGUT4UO7+aSgzr7IUU0=";
  };

  patches = [
    # Remove when https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/merge_requests/2 merged & in release
    (fetchpatch {
      name = "0001-lomiri-polkit-agent-Fix-authentication-test-with-libnotify-gteq-0.8.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/commit/415d897735b9005426ec29348a882b9080fcd808.patch";
      hash = "sha256-fAJJ5Bz4P76arhSmiWVa/8S+mb/NqPr65Nm3MkwKtjA=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/merge_requests/9 merged & in release
    (fetchpatch {
      name = "0002-lomiri-polkit-agent-Make-tests-optional-and-use-BUILD_TESTING.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/commit/908177fa24b79b06161116c3c274357122984d36.patch";
      hash = "sha256-duHx4iNqgAlS649BO1s6D5E2SX9MPRCKb+mit+2cybM=";
    })

    # Remove when https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/merge_requests/10 merged & in release
    (fetchpatch {
      name = "0003-lomiri-polkit-agent-Explicitly-look-for-properties-cpp.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/commit/08bf36e50025aeefc5ba388d6d0f84d760add9cb.patch";
      hash = "sha256-OFzj/FFXm1fX6+1GY97CON7Nne9wVPmQAxVFpP9rIpU=";
    })
  ];

  postPatch = ''
    # Partial application of still-under-discussion https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/merge_requests/8
    substituteInPlace data/lomiri-polkit-agent.service.in \
      --replace-fail 'After=lomiri-full-greeter.service lomiri-full-shell.service lomiri-greeter.service lomiri-shell.service' 'After=graphical-session.target' \
      --replace-fail 'PartOf=' 'PartOf=lomiri.service ' \
      --replace-fail 'WantedBy=' 'WantedBy=lomiri.service '

    # Workaround to avoid coredump on logout
    # https://gitlab.com/ubports/development/core/lomiri-polkit-agent/-/issues/1
    substituteInPlace service/main.cpp \
      --replace-fail 'retval.set_value(0);' 'try { retval.set_value(0); } catch (const std::future_error& ex) {}'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    libnotify
    polkit
    properties-cpp
  ];

  nativeCheckInputs = [
    dbus
    (python3.withPackages (ps: with ps; [ python-dbusmock ]))
  ];

  checkInputs = [
    dbus-test-runner
    gtest
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Parallelism breaks dbus during tests
  enableParallelChecking = false;

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Policy kit agent for the Lomiri desktop";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-polkit-agent";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
  };
})
