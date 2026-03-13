# tracy CPM uses NAME `json` but nixpkgs provides `nlohmann_json`.
find_package(nlohmann_json REQUIRED)

set(json_FOUND TRUE)
set(json_VERSION "${nlohmann_json_VERSION}")
