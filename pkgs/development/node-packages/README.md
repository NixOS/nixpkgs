Node.js packages
================
The `pkgs/development/node-packages` folder contains a generated collection of
[NPM packages](https://npmjs.com/) that can be installed with the Nix package
manager.

As a rule of thumb, the package set should only provide *end user* software
packages, such as command-line utilities. Libraries should only be added to the
package set if there is a non-NPM package that requires it.

When it is desired to use NPM libraries in a development project, use the
`node2nix` generator directly on the `package.json` configuration file of the
project.

The package set also provides support for multiple Node.js versions. The policy
is that a new package should be added to the collection for the latest stable LTS
release (which is currently 6.x), unless there is an explicit reason to support
a different release.

To add a package from NPM to nixpkgs:

 1. Modify `pkgs/development/node-packages/node-packages-v6.json` to add, update
    or remove package entries. (Or `pkgs/development/node-packages/node-packages-v4.json`
    for packages depending on Node.js 4.x)
 2. Run the script: `(cd pkgs/development/node-packages && ./generate.sh)`.
 3. Build your new package to test your changes:
    `cd /path/to/nixpkgs && nix-build -A nodePackages.<new-or-updated-package>`.
    To build against a specific Node.js version (e.g. 4.x):
    `nix-build -A nodePackages_4_x.<new-or-updated-package>`
 4. Add and commit all modified and generated files.

For more information about the generation process, consult the
[README.md](https://github.com/svanderburg/node2nix) file of the `node2nix`
tool.
