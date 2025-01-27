<p align="center">
  <a href="https://xenproject.org/">
    <picture>
      <source
        media="(prefers-color-scheme: light)"
        srcset="https://downloads.xenproject.org/Branding/Logos/Green+Black/xen_project_logo_dualcolor_2000x832.png">
      <source
        media="(prefers-color-scheme: dark)"
        srcset="https://xenproject.org/wp-content/uploads/sites/79/2018/09/logo_xenproject.png">
      <img
        src="https://downloads.xenproject.org/Branding/Logos/Green+Black/xen_project_logo_dualcolor_2000x832.png"
        width="512px"
        alt="Xen Project Logo">
    </picture>
  </a>
</p>

# Xen Project Hypervisor <a href="https://xenproject.org/"><img src="https://downloads.xenproject.org/Branding/Mascots/Xen-Fu-Panda-2000px.png" width="48px" align="top" alt="Xen Fu Panda"></a>

This directory begins the [Xen Project Hypervisor](https://xenproject.org/) build process.

Some other notable packages that compose the Xen Project Ecosystem include:

- `ocamlPackages.xenstore`: Mirage's `oxenstore` implementation.
- `ocamlPackages.vchan`: Mirage's `xen-vchan` implementation.
- `ocamlPackages.xenstore-tool`: XAPI's `oxenstore` utilities.
- `xen-guest-agent`: Guest drivers for UNIX domUs.
- `win-pvdrivers`: Guest drivers for Windows domUs.
- `xtf`: The Xen Test Framework.

## Updating

### Manually

1. [Update](https://xenbits.xenproject.org/gitweb/) the `package.nix` file for
   the latest branch of Xen.
   - Do not forget to set the `branch`, `version`, and `latest` attributes.
   - The revisions are preferably commit hashes, but tag names are acceptable
     as well.
1. Make sure it builds.
1. Use the NixOS module to test if dom0 boots successfully on the new version.
1. Make sure the `meta` attributes evaluate to something that makes sense. The
   following one-line command is useful for testing this:

   ```console
   echo -e "\033[1m$(nix eval .#xen.meta.description --raw 2> /dev/null)\033[0m\n\n$(nix eval .#xen.meta.longDescription --raw 2> /dev/null)"
   ```

1. Run `xtf --all --host` as root when booted into the Xen update, and make
   sure no important tests fail.
1. Clean up your changes and commit them, making sure to follow the
   [Nixpkgs Contribution Guidelines](../../../../CONTRIBUTING.md).
1. Open a PR and await a review from the current maintainers.

## Features

### Generic Builder

`buildXenPackage` is a helpful utility capable of building Xen when passed
certain attributes. The `package.nix` file on this directory includes all
important attributes for building a Xen package with Nix. Downstreams can
pin their Xen revision or include extra patches if the default Xen package
does not meet their needs.

### EFI

Building `xen.efi` requires an `ld` with PE support.[^2]

We use a `makeFlag` to override the `$LD` environment variable to point to our
patched `efiBinutils`. For more information, see the comment in `pkgs/build-support/xen/default.nix`.

> [!TIP]
> If you are certain you will not be running Xen in an x86 EFI environment, disable
the `withEFI` flag with an [override](https://nixos.org/manual/nixpkgs/stable/#chap-overrides)
to save you the need to compile `efiBinutils`.

## Security

We aim to support the **latest** version of Xen at any given time.
See the [Xen Support Matrix](https://xenbits.xen.org/docs/unstable/support-matrix.html)
for a list of versions. As soon as a version is no longer the newest, it should
be removed from Nixpkgs (`master`). If you need earlier versions of Xen, consider
building your own Xen by following the instructions in the **Generic Builder**
section.

> [!CAUTION]
> Pull requests that introduce XSA patches
should have the `1.severity: security` label.

### Maintainers

Xen is a particularly complex piece of software, so we are always looking for new
maintainers. Help out by [making and triaging issues](https://github.com/NixOS/nixpkgs/issues/new/choose),
[sending build fixes and improvements through PRs](https://github.com/NixOS/nixpkgs/compare),
updating the branches, and [patching security flaws](https://xenbits.xenproject.org/xsa/).

We are also looking for testers, particularly those who can test Xen on AArch64
machines. Open issues for any build failures or runtime errors you find!

## Tests

So far, we only have had one simple automated test that checks for
the correct `pkg-config` output files.

Due to Xen's nature as a type-1 hypervisor, it is not a trivial matter to design
new tests, as even basic functionality requires a machine booted in a dom0
kernel. For this reason, most testing done with this package must be done
manually in a NixOS machine with `virtualisation.xen.enable` set to `true`.

Another unfortunate thing is that none of the Xen commands have a `--version`
flag. This means that `testers.testVersion` cannot ascertain the Xen version.
The only way to verify that you have indeed built the correct version is to
boot into the freshly built Xen kernel and run `xl info`.

<p align="center">
  <a href="https://xenproject.org/">
    <img
      src="https://downloads.xenproject.org/Branding/Mascots/Xen%20Big%20Panda%204242x3129.png"
      width="96px"
      alt="Xen Fu Panda">
  </a>
</p>

[^1]: We also produce fake `git`, `wget` and `hostname` binaries that do nothing,
      to prevent the build from failing because Xen cannot fetch the sources that
      were already fetched by Nix.
[^2]: From the [Xen Documentation](https://xenbits.xenproject.org/docs/unstable/misc/efi.html):
      > For x86, building `xen.efi` requires `gcc` 4.5.x or above (4.6.x or newer
      recommended, as 4.5.x was probably never really tested for this purpose)
      and `binutils` 2.22 or newer. Additionally, the `binutils` build must be
      configured to include support for the x86_64-pep emulation (i.e.
      `--enable-targets=x86_64-pep` or an option of equivalent effect should be
      passed to the configure script).
