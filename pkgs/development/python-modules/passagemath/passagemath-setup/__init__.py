def sage_setup(distributions, *,
               interpreters=(),
               required_modules=(), optional_modules=(),
               spkgs=(),
               recurse_packages=('sage',),
               package_data=None,
               data_files=(),
               cmdclass=None,
               ext_modules=(),
               py_limited_api=False):
    r"""
    Replacement for :func:`setuptools.setup` for building distribution packages of the Sage library

    INPUT:

    - ``distributions`` -- (typically one-element) sequence of strings, the distribution names
      shipped with this distribution package.

    - ``interpreters`` -- sequence of strings, the interpreters to build with :mod:`sage_setup.autogen`.

    - ``required_modules`` -- sequence of strings, pkgconfig modules that are required for the build.

    - ``optional_modules`` -- sequence of strings, pkgconfig modules to checked for the build.

    - ``spkgs`` -- sequence of strings, SPKGs required for the build.

    - ``recurse_packages`` -- sequence of strings, namespace packages to search.

    - ``package_data`` -- ``None`` or a dictionary mapping package names to lists of filename
      glob patterns, the package data to install.

      * If ``None``, all of ``package_data`` is taken from ``pyproject.toml``.

      * If a dictionary, use it as package data and ignore ``package_data`` in ``pyproject.toml``.

    - ``cmdclass` -- ``None`` or a dictionary.
    """
    import time

    from setuptools import setup, find_namespace_packages
    from distutils import log
    from setuptools.dist import Distribution
    from sage_setup.command.sage_build_ext_minimal import sage_build_ext_minimal
    from sage_setup.command.sage_build_py import sage_build_py
    from sage_setup.cython_options import compiler_directives, compile_time_env_variables
    from sage_setup.extensions import create_extension
    from sage_setup.find import find_python_sources, find_extra_files

    # Work around a Cython problem in Python 3.8.x on macOS
    # https://github.com/cython/cython/issues/3262

    import platform
    if platform.system() == 'Darwin':
        import multiprocessing
        multiprocessing.set_start_method('fork', force=True)

    # setuptools plugins considered harmful:
    # If build isolation is not in use and setuptools_scm is installed,
    # then its file_finders entry point is invoked, which we don't need.
    # Workaround from ​https://github.com/pypa/setuptools_scm/issues/190#issuecomment-351181286
    try:
        import setuptools_scm.integration
        setuptools_scm.integration.find_files = lambda _: []
    except ImportError:
        pass

    # And with setuptools_scm 8, we get more trouble:
    # LookupError: pyproject.toml does not contain a tool.setuptools_scm section
    # LookupError: setuptools-scm was unable to detect version ...
    # We just remove all handling of "setuptools.finalize_distribution_options" entry points.
    Distribution._removed = staticmethod(lambda ep: True)

    # Different workaround: disable `walk_revctrl` in setuptools
    # This is needed for setuptools_scm >= 8, should work for any version
    import setuptools.command.egg_info
    setuptools.command.egg_info.walk_revctrl = lambda: ()

    import os
    import sys

    from sage_setup.excepthook import excepthook
    sys.excepthook = excepthook

    if cmdclass is None:
        cmdclass = dict()
    else:
        cmdclass = dict(cmdclass)
    cmdclass.update(dict(build_ext=sage_build_ext_minimal,
                         build_py=sage_build_py))

    options = {}

    sdist = len(sys.argv) > 1 and (sys.argv[1] in ["sdist", "egg_info", "dist_info"])

    # ########################################################
    # ## Discovering Sources
    # ########################################################
    if sdist:
        extensions = []
        python_modules = []
        python_packages = []
    else:

        if spkgs:
            try:
                from sage.config import make
            except ImportError:
                pass
            else:
                make(" ".join(f"{spkg}-ensure" for spkg in spkgs))

        from sage_setup.setenv import setenv
        setenv()

        import sage.env
        sage.env.default_required_modules = required_modules
        sage.env.default_optional_modules = optional_modules

        import sysconfig

        extension_kwds = {}
        if py_limited_api and os.environ.get('CIBUILDWHEEL', None) and sys.version_info >= (3, 12, 0, 0) and sysconfig.get_config_var("Py_GIL_DISABLED") != 1:
            # https://cibuildwheel.pypa.io/en/stable/options/#examples_8
            # https://cython.readthedocs.io/en/latest/src/userguide/limited_api.html#setuptools-and-setup-py
            extension_kwds['define_macros'] = [("Py_LIMITED_API", 0x030C0000)]
            extension_kwds['py_limited_api'] = True
            options["bdist_wheel"] = {"py_limited_api": "cp312"}

        if interpreters:
            log.info("Generating auto-generated sources")
            # from sage_setup.autogen import autogen_all
            # autogen_all()
            from sage_setup.autogen.interpreters.internal import rebuild
            rebuild(os.path.join("sage", "ext", "interpreters"),
                    interpreters=interpreters,
                    distribution=distributions[0], force=True)

        log.info("Discovering Python/Cython source code....")
        t = time.time()

        python_packages, python_modules, cython_modules = find_python_sources(
            '.', recurse_packages, distributions=distributions, extension_kwds=extension_kwds)
        extra_files = find_extra_files(
            '.', recurse_packages, '/doesnotexist', distributions=distributions)

        if package_data is not None:
            package_data.update({"": [f
                                      for pkg, files in extra_files.items()
                                      for f in files]})
            python_packages += list(package_data)

        log.warn('python_packages = {0}'.format(sorted(python_packages)))
        log.warn('python_modules = {0}'.format(sorted(m if isinstance(m, str) else m.name for m in python_modules)))
        log.warn('cython_modules = {0}'.format(sorted(m if isinstance(m, str) else m.name for m in cython_modules)))
        log.warn('package_data = {0}'.format(package_data))

        log.info(f"Discovered Python/Cython sources, time: {(time.time() - t):.2f} seconds.")

        if cython_modules:
            # from sage_build_cython:
            import Cython.Compiler.Options
            Cython.Compiler.Options.embed_pos_in_docstring = True
            gdb_debug = os.environ.get('SAGE_DEBUG', None) != 'no'

            try:
                from Cython.Build import cythonize
                from sage.env import cython_aliases, sage_include_directories
                from sage.misc.package_dir import cython_namespace_package_support
                with cython_namespace_package_support():
                    extensions = cythonize(
                        cython_modules,
                        include_path=[".", *sage_include_directories(use_sources=False)], # Nix fix to find .pxd files.
                        compile_time_env=compile_time_env_variables(),
                        compiler_directives=compiler_directives(False),
                        aliases=cython_aliases(),
                        create_extension=create_extension,
                        gdb_debug=gdb_debug,
                        nthreads=4)
            except Exception as exception:
                log.warn(f"Exception while cythonizing source files: {repr(exception)}")
                raise
        else:
            extensions = []

    kwds = {}

    if package_data is not None:
        kwds['package_data'] = package_data

    setup(cmdclass=cmdclass,
          packages=python_packages,
          py_modules=python_modules,
          data_files=data_files,
          ext_modules=extensions + list(ext_modules),
          options=options,
          **kwds
    )
