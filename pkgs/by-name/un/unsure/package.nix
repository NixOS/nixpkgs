{
  buildDartApplication,
  fetchFromGitHub,
  lib,
}:

buildDartApplication {
  pname = "unsure";
  version = "0.4.0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "filiph";
    repo = "unsure";
    rev = "123712482b7053974cbef9ffa7ba46c1cdfb765f";
    hash = "sha256-rn10vy6l12ToiqO4vGVT4N7WNlj6PY/r+xVzjmYqILw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = {
    description = "Unsure Calculator";
    homepage = "https://github.com/filiph/unsure";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rksm ];
  };
}
