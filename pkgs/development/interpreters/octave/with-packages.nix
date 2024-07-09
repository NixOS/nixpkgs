{ buildEnv, octavePackages }:

# Takes the buildEnv defined for Octave and the set of octavePackages, and returns
# a function, which when given a function whose return value is a list of extra
# packages to install, builds and returns that environment.
f: let packages = f octavePackages; in buildEnv.override { extraLibs = packages; }
