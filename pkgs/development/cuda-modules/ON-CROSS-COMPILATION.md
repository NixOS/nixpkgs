# On cross-compilation

> [!NOTE]
>
> I am also hesitant to discourage future contributors by declaring this
> impossible. Perhaps we could document precisely the project state, attempted
> solutions, and technical considerations and leave open the question how to
> move forward?
>
> - @samuela

## Summary

The CUDA redistributables[^1], individually packaged pieces of software
historically only made available through the CUDA Toolkit, do not appear
equipped for cross-compilation. NVIDIA's documentation makes it seem possible
only with special versions of the Debian CUDA Toolkit installer[^2].

Given the NixOS CUDA Team's focus on moving to the CUDA redistributables and
eventually dropping support for the CUDA Toolkit runfile installer, adding
support for cross-compilation requires further research and analysis. That said,
contributions improving the state of support for cross-compilation are more than
welcome!

## Background

### Cross-compilation

Cross-compilation holds varying levels of importance for the diverse user base
of Nixpkgs. It allows for the building of software for a different architecture
than the one on which the build is taking place. This is particularly useful for
embedded systems, where one might want to use a powerful `x86_64` machine, but
the target is an `aarch64` device. Unfortunately, such capabilities come at a
cost: cross-compilation is a complex and error-prone process, and while Nixpkgs
may make it possible, it certainly does not make it easy.

### CUDA Toolkit installers and CUDA redistributables

With the 11.4 release of the CUDA Toolkit, NVIDIA introduced redistributables
that allow for the installation of individual components of the CUDA Toolkit
without the need for the monolithic installer. The redistributables provide a
number of benefits, including a staggering reduction in closure sizes and
fine-grained control over dependencies.

Since their introduction, the NixOS CUDA Team has made it a priority to migrate
to these smaller, more manageable packages. As such, the team has been working
to remove the CUDA Toolkit runfile installer from Nixpkgs entirely.

### Previous work

Work has been done to try to enable cross-compilation for the Nixpkgs CUDA
ecosystem. Most recently:

- [cudaPackages: enable cross-compilation
  #275560](https://github.com/NixOS/nixpkgs/pull/275560)
- [cudaPackages: enable cross-compilation (take two)
  #279952](https://github.com/NixOS/nixpkgs/pull/279952)

The approach taken in #275560 and #279952 are fundamentally the same: select the
correct versions of CUDA redistributables at the right time and place in the
build and cross-compilation should work. Though they went about this in
different ways, the former through the module system and the latter through
splicing, they faced the same problems.

Under the assumption that cross-compilation is possible with the CUDA
redistributables, the basic plan for both #275560 and #279952 was:

1. Create `cudaPackages` with `makeScopeWithSplicing'`.
2. Update `cudaPackages.backendStdenv` and the utility functions it is created
   with to be aware of cross-compilation.
3. Update the setup hooks related to `cudaPackages` to work under
   cross-compilation.
4. Build a minimal example (`cudaPackages.saxpy`) to test the changes.

## Problem

As the only way to cross-compile CUDA software, further work on
cross-compilation would necessitate packaging the Debian CUDA Toolkit installers
-- a highly non-trivial task. Beyond the difficulties inherent in repackaging a
Debian package for Nixpkgs, the logic packaging the CUDA Toolkit runfile
installer is the most outdated and least maintained portion of the Nixpkgs CUDA
ecosystem.

Putting aside the technical concerns of packaging the Debian CUDA Toolkit
installers, the NixOS CUDA Team has been working to remove the CUDA Toolkit
runfile installer entirely. The presence of the installer in Nixpkgs has caused
confusion among users, who should almost never need it or rely on it, yet
frequently do so for lack of knowledge about CUDA redistributables. While
possible to add the cross-compilation-capable Debian CUDA Toolkit installers to
Nixpkgs, it would be a step backward in the team's efforts to modernize and
simplify the Nixpkgs CUDA ecosystem.

## Resolution

Considering the following factors:

1. The growing availability of ARM servers through services such as Hetzner and
   Oracle Cloud;
2. The risks, complexity, and increased maintenance burden associated with
   packaging the Debian CUDA Toolkit installers; and
3. The uncertain value proposition for cross-compilation within the Nixpkgs CUDA
   ecosystem

I, @ConnorBaker, recommend that cross-compilation remain unimplemented within
the Nixpkgs CUDA ecosystem. Furthermore, I propose that a version of this
document be published to serve as a resource for future maintainers.

## Conclusion

In light of the challenges posed by cross-compilation within the Nixpkgs CUDA
ecosystem, particularly the incompatibility of CUDA redistributables with
cross-compilation and the risks and complexities associated with packaging the
Debian CUDA Toolkit installers, it is recommended that cross-compilation remain
unimplemented at this time. The growing availability of ARM servers and the
uncertain value proposition for cross-compilation within the Nixpkgs CUDA
ecosystem further support this recommendation.

Moving forward, it is proposed that a version of this document be published to
serve as a resource for future maintainers, providing them with the context and
reasoning behind the decision to leave cross-compilation unimplemented within
the Nixpkgs CUDA ecosystem.

[^1]: NVIDIA calls these [Tarball and Zip Archive
    Deliverables](https://developer.download.nvidia.com/compute/cuda/redist),
    but they are more commonly known as "CUDA redistributables" in the Nixpkgs
    community, as they are meant to be redistributed with software that depends
    on CUDA.
[^2]: [NVIDIA CUDA Installation Guide for Linux: CUDA Cross-Platform
    Environment](https://docs.nvidia.com/cuda/archive/12.3.2/cuda-installation-guide-linux/index.html#cuda-cross-platform-environment).

## Directions for future work

### Creation of a shim package for cross-compilation

> Superficially, I can say there's something going on with `host-*` and
> `target-*` subdirectories present in the CUDA Toolkit (of all kinds, I
> believe, cross or not).
>
> In the non-cross CUDA Toolkit, on `x86_64-linux` (that's the NixOS system
> name) there will be a `host-linux-x64` and `target-linux-x64` subdirectory in
> the root of the CUDA Toolkit.
>
> In the cross compilation CUDA Toolkit, the values might well be something like
> `host-linux-x64` with `target-linux-sbsa` (ARM servers) or
> `target-linux-aarch64` (Jetson devices).
>
> I'd have to spin up an Ubuntu system to install the cross-compilation version
> of the CUDA Toolkit and trace through the flow of CMake to see how it's
> driving cross-compilation.
>
> I fear that beyond the presence of these host and target directories, the
> binaries in the cross-compilation version of the CUDA Toolkit are different
> from those offered in the redistributables -- though I haven't done any sort
> of analysis on the individual binaries themselves, I worry they're compiled
> differently from NVIDIA's sources in such a way that we cannot mimic the
> changes necessary for cross-compilation in an ad-hoc manner.
>
> - @ConnorBaker

> It's also not clear to me that this is fundamentally impossible. For example,
> what about a shim package that extracts just the relevant host-* and target-*
> directories from the runfile package and integrates them with
> cudaPackages.cuda_nvcc?
> - @samuela

### Analyze the differences between the redistributables and the Debian installer

### Differences between CUDA NVCC and CUDA Toolkit Debian installer
