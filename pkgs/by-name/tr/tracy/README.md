# Overview

Tracy uses [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake) to manage its dependencies.
CPM normally downloads dependencies during cmake configure, but that is incompatible with a
nixpkg build. This package uses several [Devendoring Strategies](#devendoring-strategies)
to provide dependencies to upstream's cmake build environment.

| Strategy                      | When to Use                                          |
|-------------------------------|------------------------------------------------------|
| nixpkgs                       | CPM NAME matches cmake package name                  |
| nixpkgs FindPackage           | CPM NAME or target name differs from nixpkgs         |
| nixpkgs src                   | Need different build options than nixpkgs default    |
| vendored                      | Package not in nixpkgs or incompatible               |

# Dependencies by Version

## Tracy 0.11.x

| Dependency        | Tracy Ver | nixpkgs Ver | Strategy        | Notes                     |
|-------------------|-----------|-------------|-----------------|---------------------------|
| capstone          | 5.0.1     | 5.0.6       | nixpkgs         |                           |
| glfw              | 3.3.8     | 3.4         | nixpkgs         |                           |
| wayland-protocols | 1.32      | 1.46        | nixpkgs         | XML protocol files only   |

## Tracy 0.12.x

| Dependency           | Tracy Ver        | nixpkgs Ver | Strategy            | Notes                          |
|----------------------|------------------|-------------|---------------------|--------------------------------|
| capstone             | 6.0.0-Alpha1     | 5.0.6       | vendored            | Needs v6 alpha                 |
| ImGui                | 1.91.9b-docking  | 1.91.4      | vendored            | Needs docking branch           |
| nfd                  | 1.2.1            | 1.2.1       | nixpkgs src         | ABI mismatch (NFD_PORTAL)      |
| PackageProject.cmake | 1.11.1           | -           | vendored            | Transitive dep of PPQSort      |
| PPQSort              | 1.0.5            | -           | vendored            | Not in nixpkgs                 |
| zstd                 | 1.5.6            | 1.5.7       | nixpkgs FindPackage | `Findzstd.cmake` alias         |
| wayland-protocols    | 1.37             | 1.46        | nixpkgs             | XML protocol files only        |

## Tracy 0.13.x

| Dependency           | Tracy Ver        | nixpkgs Ver | Strategy              | Notes                          |
|----------------------|------------------|-------------|-----------------------|--------------------------------|
| base64               | 0.5.2            | -           | vendored              | Not in nixpkgs                 |
| capstone             | 6.0.0-Alpha5     | 5.0.6       | vendored              | Needs v6 alpha                 |
| curl                 | 8.17.0           | 8.17.0      | nixpkgs               |                                |
| ImGui                | 1.92.5-docking   | 1.91.4      | vendored              | Needs docking branch           |
| html-tidy            | 5.8.0            | 5.8.0       | nixpkgs FindPackage   | `Findtidy.cmake` shim          |
| md4c                 | 0.5.2            | 0.5.2       | nixpkgs               |                                |
| nfd                  | 1.2.1            | 1.2.1       | nixpkgs src           | ABI mismatch (NFD_PORTAL)      |
| nlohmann_json        | 3.12.0           | 3.12.0      | nixpkgs FindPackage   | `Findjson.cmake` shim          |
| PackageProject.cmake | 1.11.1           | -           | vendored              | Transitive dep of PPQSort      |
| PPQSort              | 1.0.6            | -           | vendored              | Not in nixpkgs                 |
| pugixml              | 1.15             | 1.15        | nixpkgs               |                                |
| usearch              | 2.21.3           | -           | vendored              | Not in nixpkgs                 |
| wayland-protocols    | 1.37             | 1.46        | nixpkgs               | XML protocol files only        |
| zstd                 | 1.5.6            | 1.5.7       | nixpkgs FindPackage   | `Findzstd.cmake` alias         |

# Devendoring Strategies

## Strategy: nixpkgs

The CPM `NAME` matches the cmake package name and the package provides cmake config or pkg-config.

### Mechanism

With `CPM_LOCAL_PACKAGES_ONLY=TRUE`, CPM calls `find_package()` before attempting download. If the
nixpkgs package is found, CPM uses it.

### Implementation

Add the nixpkgs dependency to `extrabuildInputs`.

## Strategy: nixpkgs FindPackage

A compatible nixpkgs package exists but either:
- CPM uses a different `NAME` than the cmake package name
- cmake target names differ from what tracy expects

### Mechanism

Find modules in `CMAKE_MODULE_PATH` are tried before config files. When `find_package(foo)` is called, cmake finds our `Findfoo.cmake` which can delegate to the real package and create any necessary aliases.

### Implementation

- Add the nixpkgs dependency to `extrabuildInputs`.
- Create a `Find<dep>.cmake` module in the `cmake` directory and adjust package and target names.

## Strategy: nixpkgs src

Package exists in nixpkgs with compatible source but upstream needs different build options.

### Mechanism

With a `CPM_<dep>_SOURCE` cmake option set, CPM finds the dependency sources in the provided directory.

### Implementation

Add the nixpkgs package `.src` attribute to the `cpmSrcs` list with a `name` attribute matching the
CPM `NAME`.

## Strategy: Vendored Source

Package is not available in nixpkgs or is incompatible.

### Mechansim

Uses the same mechanism as a nixpkg src, except the source is downloaded with a fetcher such as
`fetchFromGithub`.

### Implementation

Add an appropriate fetcher to the `cpmSrcs` list, ensuring that the name matches what CPM expects (case-sensitive).

