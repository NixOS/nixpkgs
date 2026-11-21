passagemath: Configuration module for the Sage library
==========================================================

`passagemath <https://github.com/passagemath/passagemath>`__ is open
source mathematical software in Python, released under the GNU General
Public Licence GPLv2+.

It is a fork of `SageMath <https://www.sagemath.org/>`__, which has been
developed 2005-2025 under the motto “Creating a Viable Open Source
Alternative to Magma, Maple, Mathematica, and MATLAB”.

The passagemath fork was created in October 2024 with the following
goals:

-  providing modularized installation with pip, thus completing a `major
   project started in 2020 in the Sage
   codebase <https://github.com/sagemath/sage/issues/29705>`__,
-  establishing first-class membership in the scientific Python
   ecosystem,
-  giving `clear attribution of upstream
   projects <https://groups.google.com/g/sage-devel/c/6HO1HEtL1Fs/m/G002rPGpAAAJ>`__,
-  providing independently usable Python interfaces to upstream
   libraries,
-  providing `platform portability and integration testing
   services <https://github.com/passagemath/passagemath/issues/704>`__
   to upstream projects,
-  inviting collaborations with upstream projects,
-  `building a professional, respectful, inclusive
   community <https://groups.google.com/g/sage-devel/c/xBzaINHWwUQ>`__,
-  developing a port to `Pyodide <https://pyodide.org/en/stable/>`__ for
   serverless deployment with Javascript,
-  developing a native Windows port.

`Full documentation <https://passagemath.org/docs/latest/html/en/index.html>`__ is
available online.

passagemath attempts to support all major Linux distributions and recent versions of
macOS. Use on Windows currently requires the use of Windows Subsystem for Linux or
virtualization.

Complete sets of binary wheels are provided on PyPI for Python versions 3.10.x-3.14.x.


About this pip-installable distribution package
-----------------------------------------------

This distribution package ``passagemath-conf`` provides:

- a single Python module, ``sage.config``, providing configuration information
  to the Sage library at the time of its installation and at its runtime

- a console script ``sage-config``, for querying the variables of ``sage.config``
  from the shell

- a sourcable shell script ``sage-env-config``, providing additional configuration
  information in the form of environment variables

The modularized distribution packages of the Sage library
may declare ``passagemath-conf`` both as a PEP 518 build-system requirement and a run-time
dependency ("install-requires").

The ``passagemath-conf`` distribution package is polymorphic:  It has several implementations.


passagemath-conf sdist on PyPI
------------------------------

This implementation of the package comes from the directory
`pkgs/sage-conf_pypi <https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_pypi/>`_.

To install, use ``pip install -v passagemath-conf``.  Using ``-v`` ensures that diagnostic
messages are displayed.

On installation (or building a wheel), it invokes ``sage_bootstrap`` to establish
a build tree (``SAGE_ROOT``) and installation tree (``SAGE_LOCAL``) for
the SageMath distribution.  By default, it uses a subdirectory of ``$HOME/.sage``
that is specific to the version of the distribution and the version of Python in
use.  If several virtual environments over the same version of Python install
``passagemath-conf``, they will share these trees.

After installation of ``passagemath-conf``, a wheelhouse containing wheels of
various libraries is available; type ``ls $(sage-config
SAGE_SPKG_WHEELS)`` to list them and ``pip install $(sage-config
SAGE_SPKG_WHEELS)/*.whl`` to install them.  After this, you can install the Sage
library, for example, using ``pip install sagemath-standard``.

Customization with environment variables:

- ``SAGE_CONF_FILE``, ``SAGE_CONF_ENV_FILE``

  To skip creation of a build tree and bring your own configuration instead,
  use the environment variables ``SAGE_CONF_FILE`` or ``SAGE_CONF_ENV_FILE``
  at the build time of the package. The files named by these variables
  are copied as ``_sage_conf.py`` and ``sage-env-config``.

  For example, to skip creation of a build tree and set no configuration
  variables at all, you can use::

    export SAGE_CONF_FILE=/dev/null

- ``SAGE_CONF_CONFIGURE_ARGS``

  If set, this is appended to the invocation of ``./configure``.

- ``SAGE_CONF_TARGETS``

  The Makefile targets to build. The default is ``build`` (which builds all
  standard non-Python and Python packages that have not been disabled).
  To disable building the wheelhouse, you can use::

    export SAGE_CONF_TARGETS=build-local


passagemath-conf in the traditional installation as Sage-the-distribution
-------------------------------------------------------------------------

The original version of the distribution package ``passagemath-conf`` is used
internally in Sage-the-distribution.  It is provided in the directory
`pkgs/sage-conf <https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf/>`_.
This version of the package is generated by the Sage distribution's ``./configure``
script.


passagemath-conf for conda
--------------------------

The version of the distribution package in the directory
`pkgs/sage-conf_conda <https://github.com/passagemath/passagemath/tree/main/pkgs/sage-conf_conda/>`_
may be used in an installation method of SageMath, where all packages
are provided by conda.  This method is described in
https://passagemath.org/docs/latest/html/en/installation/conda.html#using-conda-to-provide-all-dependencies-for-the-sage-library-experimental


passagemath-conf in downstream distributions
--------------------------------------------

If the customization through the environment variables ``SAGE_CONF_...``
does not give enough flexibility, downstream packagers and advanced developers
and users can provide their own implementation of the distribution package
to support the intended deployment of the Sage library.


License
-------

GNU General Public License (GPL) v3 or later

Upstream Contact
----------------

This package is included in the main repository of passagemath
in `pkgs/sage-conf* <https://github.com/passagemath/passagemath/tree/main/pkgs/>`_.
