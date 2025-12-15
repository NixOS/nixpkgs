> [!IMPORTANT]
> There is currently an active project to [remove packages from `nodePackages`](https://github.com/NixOS/nixpkgs/issues/229475).
> Please consider adding new packages using [another method](https://nixos.org/manual/nixpkgs/unstable/#javascript-tool-specific).

This folder contains a generated collection of [npm packages](https://npmjs.com/) that can be installed with the Nix package manager.

As a rule of thumb, the package set should only provide _end-user_ software packages, such as command-line utilities.
Libraries should only be added to the package set if there is a non-npm package that requires it.

When it is desired to use npm libraries in a development project, use the `node2nix` generator directly on the `package.json` configuration file of the project.

The package set provides support for the official stable Node.js versions.
The latest stable LTS release in `nodePackages`, as well as the latest stable current release in `nodePackages_latest`.

If your package uses native addons, you need to examine what kind of native build system it uses. Here are some examples:

- `node-gyp`
- `node-gyp-builder`
- `node-pre-gyp`

After you have identified the correct system, you need to override your package expression while adding in build system as a build input.
For example, `dat` requires `node-gyp-build`, so we override its expression in [pkgs/development/node-packages/overrides.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/overrides.nix):

```nix
{
  dat = prev.dat.override (oldAttrs: {
    buildInputs = [
      final.node-gyp-build
      pkgs.libtool
      pkgs.autoconf
      pkgs.automake
    ];
    meta = oldAttrs.meta // {
      broken = since "12";
    };
  });
}
```

### Adding and updating JavaScript packages in Nixpkgs

To add a package from npm to Nixpkgs:

1. Modify [pkgs/development/node-packages/node-packages.json](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/node-packages.json) to add, update or remove package entries to have it included in `nodePackages` and `nodePackages_latest`.
2. Run the script:

   ```sh
   ./pkgs/development/node-packages/generate.sh
   ```

3. Build your new package to test your changes:

   ```sh
   nix-build -A nodePackages.<new-or-updated-package>
   ```

    To build against the latest stable Current Node.js version (e.g. 18.x):

    ```sh
    nix-build -A nodePackages_latest.<new-or-updated-package>
    ```

    If the package doesn't build, you may need to add an override as explained above.
4. If the package's name doesn't match any of the executables it provides, add an entry in [pkgs/development/node-packages/main-programs.nix](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/node-packages/main-programs.nix). This will be the case for all scoped packages, e.g., `@angular/cli`.
5. Add and commit all modified and generated files.

For more information about the generation process, consult the [README.md](https://github.com/svanderburg/node2nix) file of the `node2nix` tool.

To update npm packages in Nixpkgs, run the same `generate.sh` script:

```sh
./pkgs/development/node-packages/generate.sh
```

#### Git protocol error

Some packages may have Git dependencies from GitHub specified with `git://`.
GitHub has [disabled unencrypted Git connections](https://github.blog/2021-09-01-improving-git-protocol-security-github/#no-more-unauthenticated-git), so you may see the following error when running the generate script:

```
The unauthenticated git protocol on port 9418 is no longer supported
```

Use the following Git configuration to resolve the issue:

```sh
git config --global url."https://github.com/".insteadOf git://github.com/
```
