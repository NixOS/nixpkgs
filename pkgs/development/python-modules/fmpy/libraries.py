from ctypes import cdll
import os
from fmpy import sharedLibraryExtension

library_dir = '@cvode@'

# load SUNDIALS shared libraries
sundials_nvecserial     = cdll.LoadLibrary(os.path.join(library_dir, 'lib', 'libsundials_nvecserial'     + sharedLibraryExtension))
sundials_sunmatrixdense = cdll.LoadLibrary(os.path.join(library_dir, 'lib', 'libsundials_sunmatrixdense' + sharedLibraryExtension))
sundials_sunlinsoldense = cdll.LoadLibrary(os.path.join(library_dir, 'lib', 'libsundials_sunlinsoldense' + sharedLibraryExtension))
sundials_cvode          = cdll.LoadLibrary(os.path.join(library_dir, 'lib', 'libsundials_cvode'          + sharedLibraryExtension))
