////////////////////////////////////////////////////////////////////////////////
//
// The University of Illinois/NCSA
// Open Source License (NCSA)
//
// Copyright (c) 2014-2021, Advanced Micro Devices, Inc. All rights reserved.
//
// Developed by:
//
//                 AMD Research and AMD HSA Software Development
//
//                 Advanced Micro Devices, Inc.
//
//                 www.amd.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal with the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
//  - Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimers.
//  - Redistributions in binary form must reproduce the above copyright
//    notice, this list of conditions and the following disclaimers in
//    the documentation and/or other materials provided with the distribution.
//  - Neither the names of Advanced Micro Devices, Inc,
//    nor the names of its contributors may be used to endorse or promote
//    products derived from this Software without specific prior written
//    permission.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
// THE CONTRIBUTORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
// OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS WITH THE SOFTWARE.
//
////////////////////////////////////////////////////////////////////////////////


#ifndef _ROCM_VERSION_H_
#define _ROCM_VERSION_H_


#ifdef __cplusplus
extern "C" {
#endif  /* __cplusplus */


#define ROCM_VERSION_MAJOR   @rocm_major@
#define ROCM_VERSION_MINOR   @rocm_minor@
#define ROCM_VERSION_PATCH   @rocm_patch@


typedef enum {
	VerSuccess=0,
	VerIncorrecPararmeters,
	VerValuesNotDefined,
	VerErrorMAX		//This should always be last value in the enumerations
} VerErrors;


//  API for getting the verion
//  Return val :  VerErros : API execution status.  The parameters are valid only when the exetution status is SUCCESS==0
VerErrors getROCmVersion(unsigned int* Major, unsigned int* Minor, unsigned int* Patch) __attribute__((nonnull)) ;
//  Usage :
//  int mj=0,mn=0,p=0,ret=0;
//  ret=getROCMVersion(&mj,&mn,&p);
//  if(ret !=VerSuccess )  // error occured
//
//  check for the values and
//


#ifdef __cplusplus
}  // end extern "C" block
#endif

#endif  //_ROCM_VERSION_H_  header guard
